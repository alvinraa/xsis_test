part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}

class GetSearchRequest extends SearchEvent {
  final String keyword;
  GetSearchRequest({required this.keyword});
}
